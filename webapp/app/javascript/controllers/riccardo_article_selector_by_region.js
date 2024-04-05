
const regionFilters = document.querySelectorAll('.region-filter');

regionFilters.forEach(button => {
  button.addEventListener('click', (event) => {
    const selectedRegion = event.currentTarget.dataset.region;
    // Send AJAX request to Rails controller with selected region
    fetch(`/articles?region=${selectedRegion}`)
      .then(response => response.json())
      .then(filteredArticles => {
        // Update the articles container with filtered articles
        //updateArticlesContainerFrontend(filteredArticles);
        updateArticlesContainerBackend(filteredArticles);
      })
      .catch(error => console.error(error));

    // Update active class for styling
    document.querySelector('.active').classList.remove('active');
    button.classList.add('active');
  });
});

// Function to update articles container with filtered articles (implementation details omitted)
// FRONTEND approach according to Gemini
function updateArticlesContainer(articles) {
  // ... logic to populate articles container with received articles
  const articlesContainer = document.querySelector('.articles-container');
  articlesContainer.innerHTML = ''; // Removes all child elements

  // Loop through filtered articles and create HTML elements
  articles.forEach(article => {
    const articleElement = document.createElement('div');
    articleElement.classList.add('article'); // Add a class for styling

    // Add article content (title, image, excerpt, etc.)
    const articleTitle = document.createElement('h3');
    articleTitle.textContent = article.title;
    articleElement.appendChild(articleTitle);

    // ... Add other elements and content based on your article data structure

    articlesContainer.appendChild(articleElement);
  });

}

function updateArticlesContainerBackend(articles) {
    // Send AJAX request to Rails controller with filtered articles
    fetch(`/articles/render?articles=${JSON.stringify(articles)}`)
      .then(response => response.text())
      .then(htmlContent => {
        const articlesContainer = document.querySelector('.articles-container');
        articlesContainer.innerHTML = htmlContent;
      })
      .catch(error => console.error(error));
  }
