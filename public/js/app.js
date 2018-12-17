var url = window.location.href;
var link = url.substring(url.lastIndexOf('/') + 1);

$("#sidebar").find("."+link).addClass("m-active");

function markLoading(el){
    el.html(`
        <div class="loading">
            <img src="/images/loader.svg" alt="">
        </div>
    `);
}

var loader = $("#loader");
function showPage() {
    loader.hide();
    document.getElementById("content-page").style.opacity = "1";
}

function showLoad() {
    loader.show();
    document.getElementById("content-page").style.opacity = "0.3";
}

// em cmt lại vì thằng edit medicine ko cần chọn ảnh vẫn đc, n sẽ dùng ảnh cũ
// $("input[type='file']").change(function(){
//     var allowedExtension = ['jpeg', 'jpg', 'png', 'gif', 'bmp'];
//     var file = $(this).val(),
//         ext = file.substring(file.lastIndexOf('.') + 1);
        
//     if(!allowedExtension.includes(ext)){
//         $(".message").html("* Image invalid.");
//         $(".message").show();
//         $(".register").hide();
//     }else{
//         $(".message").empty().hide();
//         $(".register").show();
        
//     }
// });

function showStatusPending(title, content){
    var box = $('.show-status');
    box.find('h5').text(title);
    box.find('p').find('a').attr('href','https://ropsten.etherscan.io/tx/'+content);
    box.find('p').find('a').text(content);
    box.show();
    setTimeout(function(){
        box.hide();
    }, 5000)
}

function showError(title, content){
    var box = $('.show-error');
    box.find('h5').text(title);
    box.find('p').text(content);
    box.show();
    setTimeout(function(){
        box.hide();
    }, 5000)
}

$('.btn-close').click(function(){
    $(this).closest('.box-msg').hide();
})