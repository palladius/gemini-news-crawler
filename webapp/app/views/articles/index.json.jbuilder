# frozen_string_literal: true

json.array! @articles, partial: 'articles/article', as: :article
