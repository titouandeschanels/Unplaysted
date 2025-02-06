import express from 'express';
import { getSpotifyToken } from './token';

const app = express();
const PORT:Number=3001;

// Handling GET / Request
app.get('/', (req, res) => {
    let data = "Hello World !"
    res.send(data);
})

app.get('/token', (req, res) => {
    getSpotifyToken().then((token) => {
        res.send(token);
    });
})


// Server setup
app.listen(PORT,() => {
    console.log('The application is listening '
        + 'on port http://localhost:'+PORT);
})

