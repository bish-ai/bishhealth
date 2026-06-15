export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  const { symptoms } = req.body;
  const apiKey = process.env.OPENROUTER_API_KEY;

  if (!apiKey) {
    return res.status(500).json({ 
      error: 'API key not configured',
      analysis: 'AI Analysis: Please consult healthcare professional. Recommendations: 1) Stay hydrated 2) Get rest 3) Monitor symptoms 4) Seek medical attention if needed.'
    });
  }

  try {
    const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are a health AI assistant. Provide brief general health advice. Always recommend consulting a healthcare professional.'
          },
          {
            role: 'user',
            content: `Please analyze: ${symptoms}`
          }
        ],
      }),
    });

    const data = await response.json();
    const analysis = data.choices?.[0]?.message?.content || 'Unable to analyze';

    return res.status(200).json({ analysis });
  } catch (error) {
    return res.status(500).json({ 
      error: error.message,
      analysis: 'Service unavailable. Try again later.'
    });
  }
}
