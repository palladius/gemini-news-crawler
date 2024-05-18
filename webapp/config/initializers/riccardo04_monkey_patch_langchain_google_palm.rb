
# Riccardo MonkeyPatching GoogleGemini
class Langchain::LLM::GooglePalm


  def sample_complete()
    complete(prompt: 'Please write a night-time story about the evil Amarone daemon who lived in Arena di Verona. He was a part-time Ruby on rails developer who at night went scaring tourists, particularly the ones who saw the Netflix movie "Love in the villa"', max_output_tokens: 2047)
    #.raw_response.predictions[0]['content'] %>
  end

  def summarize_with_tokens(text:, max_tokens: 256)
    # Riccardo monkeypatching.
    prompt_template = Langchain::Prompt.load_from_path(
      file_path: Langchain.root.join("langchain/llm/prompts/summarize_template.yaml")
    )
    prompt = prompt_template.format(text: text)

    complete(
      prompt: prompt,
      temperature: @defaults[:temperature],
      # Most models have a context length of 2048 tokens (except for the newest models, which support 4096).
      max_tokens: max_tokens
    )
  end

end


class Langchain::LLM::GooglePalmResponse

  def output
    #raw_response.dig("candidates").dig(0, "output")
    raw_response.dig("candidates", 0, "output")
  end

end
