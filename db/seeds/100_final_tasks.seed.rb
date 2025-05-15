# frozen_string_literal: true

Rake::Task["db:set_counter_caches"].invoke
Rake::Task["activestorage::reanalyse"].invoke
