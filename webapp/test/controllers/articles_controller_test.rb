require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { active: @article.active, author: @article.author, content: @article.content, feed_url: @article.feed_url, guid: @article.guid, hidden_blurb: @article.hidden_blurb, image_url: @article.image_url, language: @article.language, link: @article.link, published_date: @article.published_date, ricc_internal_notes: @article.ricc_internal_notes, ricc_source: @article.ricc_source, summary: @article.summary, title: @article.title } }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { active: @article.active, author: @article.author, content: @article.content, feed_url: @article.feed_url, guid: @article.guid, hidden_blurb: @article.hidden_blurb, image_url: @article.image_url, language: @article.language, link: @article.link, published_date: @article.published_date, ricc_internal_notes: @article.ricc_internal_notes, ricc_source: @article.ricc_source, summary: @article.summary, title: @article.title } }
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end
end
