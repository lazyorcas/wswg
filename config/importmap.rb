# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"

pin "stimulus", preload: false
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: false
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: false
pin_all_from "app/javascript/controllers", under: "controllers", preload: false

pin "admin", preload: false
pin "chartkick", to: "chartkick.js", preload: false
pin "Chart.bundle", to: "Chart.bundle.js", preload: false
