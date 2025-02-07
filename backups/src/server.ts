import express from 'express';
import { getArtistInfo } from './artist';
import { getAuthUrl, getAccessToken } from './login';

const app = express();
const PORT:Number=3001;

let spotifyToken : string | null = null;

app.get('/', (req, res) => {
    let data = "Hello World !"
    res.send(data);
})

// LOGIN AND TOKEN
app.get('/login', (req, res) => {
    getAuthUrl().then((url) => {
        res.redirect(url);
    });
})

app.get('/callback', (req, res) => {
    const code = req.query.code as string;
    getAccessToken(code, spotifyToken).then((data : any) => {
        spotifyToken = data.access_token;
        res.send(data);
    });
})

// ARTIST
// app.get('/artist/:id', (req, res) => {
//     const id = req.params.id;
//     getSpotifyToken(spotifyToken).then((token) => {
//         getArtistInfo(token, id).then((data) => {
//             res.send(data);
//         });
//     });
// })

// Server setup
app.listen(PORT,() => {
    console.log('The application is listening '
        + 'on port http://localhost:'+PORT);
})

