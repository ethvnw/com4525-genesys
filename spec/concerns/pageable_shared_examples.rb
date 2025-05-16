# frozen_string_literal: true

require "rails_helper"

##
# Asserts that the desktop pager is present
#
# @param per_page [Integer] the number of items that are shown per page
# @param total [Integer] the total number of items
def assert_desktop_pager(per_page, total)
  pager_href = find("#pager-desktop .page-item.next a")["href"]
  query_params = CGI.parse(URI.parse(pager_href).query || "")

  expect(page).not_to(have_selector("#pager-mobile", visible: true))
  expect(page).to(have_content("Displaying items 1-#{per_page} of #{total} in total"))
  expect(page).to(have_selector("#pager-desktop", visible: true))

  expect(query_params).not_to(include("scroll" => ["infinite"]))
  expect(query_params).to(include("page" => ["2"]))
end

##
# Asserts that the mobile pager is present
#
# @param per_page [Integer] the number of items that are shown per page
# @param total [Integer] the total number of items
def assert_infinite_scroll(per_page, total)
  pager_href = find("#pager-mobile a")["href"]
  query_params = CGI.parse(URI.parse(pager_href).query || "")

  expect(page).to(have_selector("#pager-mobile", visible: true))
  expect(page).not_to(have_content("Displaying items 1-#{per_page} of #{total} in total"))
  expect(page).not_to(have_selector("#pager-desktop", visible: true))

  expect(query_params).to(include("scroll" => ["infinite"]))
  expect(query_params).to(include("page" => ["2"]))
end

RSpec.shared_examples_for("responsive pager with infinite scroll") do |per_page, total|
  before do
    @original_size = page.driver.browser.manage.window.size
  end

  after do
    page.driver.browser.manage.window.resize_to(@original_size.width, @original_size.height)
  end

  scenario "On desktop mode", js: true do
    page.driver.browser.manage.window.resize_to(1600, 900)
    assert_desktop_pager(per_page, total)
  end

  scenario "On a smaller screen", js: true do
    page.driver.browser.manage.window.resize_to(400, 900)
    assert_infinite_scroll(per_page, total)
  end
end

RSpec.shared_examples_for("regular pager") do |per_page, total|
  before do
    @original_size = page.driver.browser.manage.window.size
  end

  after do
    page.driver.browser.manage.window.resize_to(@original_size.width, @original_size.height)
  end

  scenario "On desktop mode", js: true do
    page.driver.browser.manage.window.resize_to(1600, 900)
    assert_desktop_pager(per_page, total)
  end

  scenario "On a smaller screen", js: true do
    page.driver.browser.manage.window.resize_to(400, 900)
    assert_desktop_pager(per_page, total)
  end
end
