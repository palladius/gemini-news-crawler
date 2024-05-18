
# Riccardo MonkeyPatching GoogleGemini
class Langchain::LLM::GooglePalm


  def sample_complete()
    complete(prompt: 'Please write a night-time story about the evil Amarone daemon who lived in Arena di Verona. He was a part-time Ruby on rails developer who at night went scaring tourists, particularly the ones who saw the Netflix movie "Love in the villa"', max_output_tokens: 2047)
    #.raw_response.predictions[0]['content'] %>
  end
end


class Langchain::LLM::GooglePalmResponse

  def output
    #raw_response.dig("candidates").dig(0, "output")
    raw_response.dig("candidates", 0, "output")
  end

end
