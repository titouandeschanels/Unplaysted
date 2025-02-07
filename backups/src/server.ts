import express from 'express';
import { getSpotifyToken } from './token';
import { getArtistInfo } from './artist';

const app = express();
const PORT:Number=3001;

let spotifyToken : string | null = null;

// Handling GET / Request
app.get('/', (req, res) => {
    let data = "Hello World !"
    res.send(data);
})

app.get('/token', (req, res) => {
    getSpotifyToken(spotifyToken).then((token) => {
        spotifyToken = token;
        res.send(token);
    });
})


app.get('/artist/:id', (req, res) => {
    const id = req.params.id;
    getSpotifyToken(spotifyToken).then((token) => {
        getArtistInfo(token, id).then((data) => {
            res.send(data);
        });
    });
})

// Server setup
app.listen(PORT,() => {
    console.log('The application is listening '
        + 'on port http://localhost:'+PORT);
})

