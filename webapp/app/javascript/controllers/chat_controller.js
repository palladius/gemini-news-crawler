// copied from Gemini to create a chat.

import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["input", "messages"]
  static values = {
    url: String
  }

  sendMessage(event) {
    console.error("Ciao da Riccardo - sendMessage() start")

    Turbo.navigator.view.snapshotCache().then((snapshot) => {
      const formElement = snapshot.querySelector('form[data-action="submit->chat#sendMessage"]');
      console.log("Snapshot form values:", new FormData(formElement)); // Log the form data from the snapshot
    });

    event.preventDefault()  // Prevent default form submission

    const message = this.inputTarget.value
    console.log("[Riccardo] Message from input: ", message)  // Log

    // Clear input field
    this.inputTarget.value = ""

    // Display user message
    const userMessageElement = document.createElement('div')
    userMessageElement.classList.add('text-right', 'mb-2') // Style as needed
    userMessageElement.textContent = message
    this.messagesTarget.appendChild(userMessageElement)

    // Send message to backend
    Turbo.fetch(this.urlValue, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: message }),
      success: (response) => {
        // Append LLM response to the chat
        this.appendResponse(response)
      },
      error: (error) => {
        console.error("Error sending message:", error)
      }
    })
  }

  // appendResponse(response) {
  //   const llmResponseElement = document.createElement('div')
  //   llmResponseElement.classList.add('text-left', 'mb-2') // Style as needed
  //   llmResponseElement.textContent = response
  //   this.messagesTarget.appendChild(llmResponseElement)

  //   // Scroll to the bottom of the chat (optional)
  //   this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  // }

  appendResponse(data) {
    console.error("Ciao da Riccardo - appendResponse(data) start: ", data)

    // User message
    const userMessageElement = document.createElement('div')
    userMessageElement.classList.add('text-right', 'mb-2') // Style as needed
    userMessageElement.textContent = `Riccardo: ${data.user_message}`
    this.messagesTarget.appendChild(userMessageElement)

    // LLM response
    const llmResponseElement = document.createElement('div')
    llmResponseElement.classList.add('text-left', 'mb-2') // Style as needed
    llmResponseElement.textContent = `LLM: ${data.llm_response}`
    this.messagesTarget.appendChild(llmResponseElement)

    // Scroll to the bottom (optional)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
