import express from 'express';

const app = express();
const PORT:Number=3001;

// Handling GET / Request
app.get('/', (req, res) => {
    let data = "Hello World !"
    res.send(data);
})

// Server setup
app.listen(PORT,() => {
    console.log('The application is listening '
          + 'on port http://localhost:'+PORT);
})