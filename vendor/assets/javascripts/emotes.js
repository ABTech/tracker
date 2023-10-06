let emoticons = {
    ':party-blob:': 'https://emojis.slackmojis.com/emojis/images/1643514770/7808/party-blob.gif?1643514770',
    ':blobsob:': 'https://emojis.slackmojis.com/emojis/images/1643514690/6921/blob_sob.png?1643514690',
    ':blobtoiletspin:': 'https://github.com/thomplinds/custom-slack-emojis/blob/main/images/blobtoiletflush.gif?raw=true',
    ':blobsad:': 'https://emojis.slackmojis.com/emojis/images/1643514688/6904/blob_sad.png?1643514688',
    ':blob-spin:': 'https://emojis.slackmojis.com/emojis/images/1643515247/12652/blobspin.png?1643515247',
    ':blob-go:': 'https://emojis.slackmojis.com/emojis/images/1643514683/6858/blob_go.png?1643514683',
    ':blob_excited:': 'https://emojis.slackmojis.com/emojis/images/1643514936/9579/blob_excited.gif?1643514936',
    ':blobeyes:': 'https://emojis.slackmojis.com/emojis/images/1643514682/6848/blob_eyes.png?1643514682',
    ':blobfearful:': 'https://emojis.slackmojis.com/emojis/images/1643514682/6850/blob_fearful.png?1643514682',
};

$(function() {
    // For each emote,
    for (const [text, url] of Object.entries(emoticons)) {
        // Find nodes with it
        let text_nodes = $(`:contains("${text}")`).contents();

        // Filter to text (type 3) nodes that definitely contain it
        // (:contains doesn't guarantee this: https://stackoverflow.com/a/29418265)
        text_nodes = text_nodes.filter(function() {
            return this.nodeType === 3 && this.textContent.indexOf(text) > -1;
        });

        // replace the emote text with the img
        text_nodes.replaceWith(function() {
            return this.nodeValue.replace(RegExp(text, "g"),
                // .emote-inline doesn't actually do anything
                // height should end up roughly true line height
                // alt text shows if image is not found and allows copy-paste
                `<img class="emote-inline" style="height:1.4em; margin-bottom:-0.2em;" src="${url}" alt="${text}"/>`
            );
        });
    }
})
