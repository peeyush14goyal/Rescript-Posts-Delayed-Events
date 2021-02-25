@val external document: {..} = "document"
@val external window: {..} = "window"

let restorePost = (idVal, id) => {
  window["clearTimeout"](id) -> ignore

  let blk = document["getElementById"](`block-${idVal}`)
  blk["style"]["display"] = "block"

  let delBlk = document["getElementById"](`delete-block-${idVal}`)
  document["body"]["removeChild"](delBlk)
}
