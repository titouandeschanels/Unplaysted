require('dotenv').config();
let tokenExpiration: number | null = null;

// check if a token already exists and if it's still valid
function isTokenValid(spotifyToken: string | null) {
    if (spotifyToken === null || tokenExpiration === null) {
        return false;
    }

    const now =  Math.floor(Date.now() / 1000);
    return tokenExpiration > now;
}

async function getSpotifyToken(spotifyToken: string | null) {
    if (isTokenValid(spotifyToken)) {
        return spotifyToken;
    }
    const CLIENT_ID = process.env.CLIENT_ID;
    const CLIENT_SECRET = process.env.CLIENT_SECRET;

    const response = await fetch("https://accounts.spotify.com/api/token", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `grant_type=client_credentials&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}`
    });

    const data = await response.json();
    tokenExpiration = Math.floor(Date.now() / 1000) + data.expires_in;
    return data.access_token;
}

export { getSpotifyToken };