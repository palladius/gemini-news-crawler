# frozen_string_literal: true

require 'application_system_test_case'

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:one)
  end

  test 'visiting the index' do
    visit articles_url
    assert_selector 'h1', text: 'Articles'
  end

  test 'should create article' do
    visit articles_url
    click_on 'New article'

    check 'Active' if @article.active
    fill_in 'Author', with: @article.author
    fill_in 'Content', with: @article.content
    fill_in 'Feed url', with: @article.feed_url
    fill_in 'Guid', with: @article.guid
    fill_in 'Hidden blurb', with: @article.hidden_blurb
    fill_in 'Image url', with: @article.image_url
    fill_in 'Language', with: @article.language
    fill_in 'Link', with: @article.link
    fill_in 'Published date', with: @article.published_date
    fill_in 'Ricc internal notes', with: @article.ricc_internal_notes
    fill_in 'Ricc source', with: @article.ricc_source
    fill_in 'Summary', with: @article.summary
    fill_in 'Title', with: @article.title
    click_on 'Create Article'

    assert_text 'Article was successfully created'
    click_on 'Back'
  end

  test 'should update Article' do
    visit article_url(@article)
    click_on 'Edit this article', match: :first

    check 'Active' if @article.active
    fill_in 'Author', with: @article.author
    fill_in 'Content', with: @article.content
    fill_in 'Feed url', with: @article.feed_url
    fill_in 'Guid', with: @article.guid
    fill_in 'Hidden blurb', with: @article.hidden_blurb
    fill_in 'Image url', with: @article.image_url
    fill_in 'Language', with: @article.language
    fill_in 'Link', with: @article.link
    fill_in 'Published date', with: @article.published_date
    fill_in 'Ricc internal notes', with: @article.ricc_internal_notes
    fill_in 'Ricc source', with: @article.ricc_source
    fill_in 'Summary', with: @article.summary
    fill_in 'Title', with: @article.title
    click_on 'Update Article'

    assert_text 'Article was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Article' do
    visit article_url(@article)
    click_on 'Destroy this article', match: :first

    assert_text 'Article was successfully destroyed'
  end
end
