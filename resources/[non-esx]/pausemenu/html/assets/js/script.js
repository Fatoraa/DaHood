$('body').hide();

window.addEventListener('message', (event) => {
    if (event.data.type === "ui") {
        if (event.data.status) {
            $('body').fadeIn();
        } else {
            $('body').fadeOut();
        }
    }
});

document.onkeydown = e => {
    if (e.keyCode === 27)
        $.post('http://pausemenu/close', JSON.stringify({}));
}

document.onclick = e => {
    switch (e.target.id) {
        case "riprendi": 
            $.post('http://pausemenu/close', JSON.stringify({}));
            break;
        case "mappa":
            $.post('http://pausemenu/map', JSON.stringify({}));
            break;
        case "impostazioni":
            $.post('http://pausemenu/settings', JSON.stringify({}));
            break;
        case "discord":
            window.invokeNative('openUrl', 'https://discord.gg/cfx')
            $.post('http://pausemenu/close', JSON.stringify({}));
            break;
        case "quit":
            $.post('http://pausemenu/quit', JSON.stringify({}));
            break;
    }
}