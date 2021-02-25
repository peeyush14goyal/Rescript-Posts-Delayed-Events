@val external document: {..} = "document"
@val external window: {..} = "window"

let deleteDiv = (posts, id) => {
  let postDiv = document["getElementById"](`block-${id}`)
  let parentDiv = document["createElement"]("div")
  parentDiv["id"] = `delete-block-${id}`
  parentDiv["innerHTML"] = switch Belt.Int.fromString(id) {
    | Some(x) => {
      `<div class="post-deleted pt-1">
      <p class="text-center">
        This post from <em>${posts[((x))]->PostMod.Post.title} by ${posts[((x))]->PostMod.Post.author}</em> will be
        permanently removed in 10 seconds.
      </p>
      <div class="flex-center">
        <button id="block-restore-${id}" class="button button-warning mr-1">
          Restore
        </button>
        <button id="block-delete-immediate-${id}" class="button button-danger">
          Delete Immediately
        </button>
      </div>
      <div class="post-deleted-progress"></div>
    </div>`
    }

    | None => ``
  }

  document["body"]["insertBefore"](parentDiv, postDiv)
}

let removeChild = (posts, idVal) => {
  let blk = document["getElementById"](`block-${idVal}`)
  deleteDiv(posts, idVal) -> ignore

  let restoreBlk = document["getElementById"](`block-restore-${idVal}`)
  let delBlk = document["getElementById"](`block-delete-immediate-${idVal}`)
  blk["style"]["display"] = "none"

  let timer_id = window["setTimeout"](() => Delete.deletePost(idVal, "None"), 10000)
  delBlk["addEventListener"]("click",() => Delete.deletePost(idVal, timer_id)) -> ignore
  restoreBlk["addEventListener"]("click",() => Restore.restorePost(idVal, timer_id))
}
