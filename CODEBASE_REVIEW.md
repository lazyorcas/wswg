# Codebase Review (Rails + System Design)

## Scope
This review is based on a static analysis of application structure, routing, controllers, jobs, security initializers, and deployment configuration.

## Strengths

1. **Strong domain segmentation and modularity**
   - The codebase uses concerns and namespaced classes to separate responsibilities (`SearchQuery` concerns, `Event` concerns, business-specific controllers/components).
   - This usually keeps model and controller logic easier to evolve as the product surface grows.

2. **Good baseline abuse protection**
   - `Rack::Attack` includes multiple throttles for login, account creation, search query endpoints, and map endpoints.
   - This is a practical baseline for reducing brute force and scraping pressure.

3. **Background processing architecture is in place**
   - Search orchestration is pushed into ActiveJob (`SearchQuery::QueryJob`, `SearchQuery::PollForSearchesResultsJob`) instead of entirely synchronous controller execution.

4. **Data model includes meaningful indexing**
   - The schema shows broad index coverage on high-traffic tables, including GIN indexes for full-text vectors and composite indexes on bookmark/search-related records.

## High-priority findings

1. **Likely bug in current-person routing check**
   - `ApplicationController#set_current_person` checks `request.path.start_with?("/businesses")`, but routes are mounted under singular `/business`.
   - Effect: business traffic may be resolved as user/visitor context unexpectedly.
   - Recommendation: align this path check with route reality (or move to route helper/namespace-based detection).

2. **Polling job blocks worker threads/processes with `sleep` loop**
   - `SearchQuery::PollForSearchesResultsJob` loops up to 10 times with `sleep 1`.
   - Effect: blocked workers reduce queue throughput and can amplify latency under load.
   - Recommendation: replace in-job sleeping with re-enqueue/backoff strategy (`retry_job wait:` or scheduled follow-up jobs).

3. **Over-broad exception rescue in user creation**
   - `UsersController#create` rescues all exceptions and turns them into generic user-facing errors.
   - Effect: operational failures (DB/network/bug) become hard to distinguish from expected validation failures.
   - Recommendation: rescue specific exceptions (e.g., `ActiveRecord::RecordInvalid`) and allow unknown exceptions to bubble after observability hooks.

## Security and platform observations

1. **Content Security Policy is effectively disabled**
   - `config/initializers/content_security_policy.rb` is still commented out.
   - Risk: fewer browser-level protections against XSS and script injection.
   - Recommendation: enable a restrictive baseline CSP and progressively relax only where required.

2. **OmniAuth allows GET and POST request methods**
   - `OmniAuth.config.allowed_request_methods = %i[get post]`.
   - Risk: GET auth initiation can increase CSRF/link-trigger exposure surfaces.
   - Recommendation: prefer POST-only unless a hard compatibility requirement exists.

3. **Production Active Storage uses local disk**
   - `config.active_storage.service = :local` in production.
   - Risk: non-shared filesystem in multi-instance deployments, fragile backups, and migration complexity.
   - Recommendation: move to object storage (e.g., S3-compatible) for scalability and durability.

## Maintainability observations

1. **Insufficient top-level documentation**
   - `README.md` currently only contains the project name.
   - Recommendation: add setup, env vars, architecture overview, worker model, and deployment/runbook sections.

2. **Job reliability baseline could be improved**
   - `ApplicationJob` has no active global retry/discard policy currently enabled.
   - Recommendation: define explicit retry/discard defaults (or per-job policies) for transient vs terminal failure classes.

## Suggested next actions (ordered)

1. Fix business-context path detection bug in `ApplicationController`.
2. Refactor polling job to non-blocking re-enqueue/backoff.
3. Tighten auth/security defaults (CSP enabled, OmniAuth POST-only).
4. Move production Active Storage off local disk.
5. Add production-grade README and ops runbook content.
6. Add job retry/discard policies and dead-letter observability.
