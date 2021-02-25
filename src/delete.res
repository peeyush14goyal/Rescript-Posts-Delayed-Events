@val external document: {..} = "document"
@val external window: {..} = "window"

let deletePost = (idVal, id) => {
  switch id {
    | "None" => ()
    | id => window["clearTimeout"](id)
  }

  let blk = document["getElementById"](`block-${idVal}`)
  document["body"]["removeChild"](blk) -> ignore

  let delBlk = document["getElementById"](`delete-block-${idVal}`)
  document["body"]["removeChild"](delBlk)
}
