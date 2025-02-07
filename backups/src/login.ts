require('dotenv').config();
import querystring from 'querystring';

let tokenExpiration: number | null = null;

const CLIENT_ID = process.env.CLIENT_ID!;
const CLIENT_SECRET = process.env.CLIENT_SECRET!;
const REDIRECT_URI = process.env.REDIRECT_URI!;

// check if a token already exists and if it's still valid
function isTokenValid(spotifyToken: string | null) {
    if (spotifyToken === null || tokenExpiration === null) {
        return false;
    }

    const now =  Math.floor(Date.now() / 1000);
    return tokenExpiration > now;
}

// use to get the code
async function getAuthUrl() {
    const scope = "user-read-private user-read-email playlist-read-private";

    const authURL = "https://accounts.spotify.com/authorize?" +
    querystring.stringify({
        response_type: "code",
        client_id: CLIENT_ID,
        scope: scope,
        redirect_uri: REDIRECT_URI
    });
    console.log(CLIENT_ID);
    return authURL;
}

// transform the code into a token
async function getAccessToken(code : string, spotifyToken: string | null) {

    if (isTokenValid(spotifyToken)) {
        return spotifyToken;
    }

    if (!code) {
        throw new Error("Missing code");
    }

    try {
        const response = await fetch("https://accounts.spotify.com/api/token", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: querystring.stringify({
                grant_type: "authorization_code",
                client_id: CLIENT_ID,
                client_secret: CLIENT_SECRET,
                code: code,
                redirect_uri: REDIRECT_URI
            })
        });

        const data = await response.json();
        tokenExpiration = Math.floor(Date.now() / 1000) + data.expires_in;
        spotifyToken = data.access_token;
        return data;

    } catch (error: any) {
        throw new Error(error.response.data.error_description);
    }
}


async function getNonOUATHSpotifyToken(spotifyToken: string | null) {
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


export { getAuthUrl, getAccessToken };