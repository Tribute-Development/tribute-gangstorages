window.onload = function () {
    $('#a-notify').hide();
}

function display(bool) {
    if(bool) {
        $('#a-notify').show();
    } else {
        $('#a-notify').hide();
    }
}

window.addEventListener('message', function(event) {
    let data = event.data
    if (data.type == 'show') {
        display(true)
    } else {
        display(false)
    }
})