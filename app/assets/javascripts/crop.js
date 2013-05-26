$(function() {
  $('#cropbox').Jcrop({
    onChange: update_crop,
    onSelect: update_crop,
    setSelect: [0, 0, 400, 400],
    aspectRatio: 1
  })
})


function update_crop(coords) {
  var rx = 100/coords.w
  var ry = 100/coords.h
  $('#preview').css({
    width: Math.round(rx * parseFloat($('#crop_data').attr('data-pre-crop-width'))) + 'px',
    height: Math.round(ry * parseFloat($('#crop_data').attr('data-pre-crop-height'))) + 'px',
    marginLeft: '-' + Math.round(rx * coords.x) + 'px',
    marginTop: '-' + Math.round(ry * coords.y) + 'px'
  })

  var ratio_w = $('#crop_data').attr('data-original-width') / $('#crop_data').attr('data-pre-crop-width')
  $('#crop_x').val(Math.floor(coords.x * ratio_w))
  $('#crop_y').val(Math.floor(coords.y * ratio_w))
  $('#crop_w').val(Math.floor(coords.w * ratio_w))
  $('#crop_h').val(Math.floor(coords.h * ratio_w))  
}
