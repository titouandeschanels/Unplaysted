async function getArtistInfo(spotifyToken : string, id : string) {
    const response = await fetch(`https://api.spotify.com/v1/artists/${id}`, {
        method: "GET",
        headers: {
            Authorization: `Bearer ${spotifyToken}`
        },
    });

    const data = await response.json();

    if (!response.ok) {
        throw new Error(`Error API Spotify Get Artist : ${data.error.message}`);
    }

    return data;
}

export { getArtistInfo };