/**
 * 在本地进行文件保存
 * @param  {String} data     要保存到本地的图片数据
 * @param  {String} filename 文件名
 */
var saveFile = function(data, filename){
    var save_link = document.createElementNS('http://www.w3.org/1999/xhtml', 'a');
    save_link.href = data;
    save_link.download = filename;
   
    var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
    save_link.dispatchEvent(event);
};

function getImageData(img, type){
	var canvas = document.createElement("canvas");
    canvas.width = img.width ;
    canvas.height = img.height;

    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0, img.width , img.height );

    var dataURL = canvas.toDataURL("image/" + type);
    return dataURL;
}


function saveSvgAsPng(svg, fileName, imageContainer){
	var tmpImageContainer = 'imageContainer';
	if(imageContainer){
		tmpImageContainer = imageContainer;
	}
	$(svg).find('image').each(function(i){
		var tmpImg = new Image();
		tmpImg.src = this.href.baseVal;
		var imageData = getImageData(tmpImg, "png");
		this.href.baseVal = imageData;
		
	});
	var svgData = new XMLSerializer().serializeToString(svg);
	var svgImageData = "data:image/svg+xml;base64," + Base64.encode(svgData);
	
	var bounds = graph.getGraphBounds(); 
	var w = Math.round(bounds.x + bounds.width); 
	var h = Math.round(bounds.y + bounds.height); 
	var img = document.createElement("img");
	img.width = w;
	img.height = h;
	img.src = svgImageData;
	$("#" + tmpImageContainer).append(img);
	img.onload = function() {
		var pngImageData = getImageData(img, "png");
		$(img).remove();
		saveFile(pngImageData, fileName);
		
	};
}