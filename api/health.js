export default function handler(req, res) {
  if (req.method === 'GET') {
    return res.status(200).json({
      heartRate: Math.floor(Math.random() * 40) + 60,
      steps: Math.floor(Math.random() * 15000) + 3000,
      calories: Math.floor(Math.random() * 600) + 200,
      sleep: (Math.random() * 4 + 5).toFixed(1)
    });
  }
  res.status(405).json({ message: 'Method not allowed' });
}
