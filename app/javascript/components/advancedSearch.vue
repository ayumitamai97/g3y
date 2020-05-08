<template>
  <div :class='modalVisibilityClass'>
    <div class='modal-background'></div>
    <div class='modal-card mt-20'>
      <div class='modal-card-head'>
        <h1 class='modal-card-title is-2'>Advanced Search</h1>
        <button class='delete' @click='closeModal'></button>
      </div>
      <div class='modal-card-body'>
      </div>
      <div class='modal-card-foot'>
        <button class='button'>Search</button>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
export default {
  // data() {
  //   modalVisibility: true
  // },
  computed: {
    modalVisibilityClass(): String {
      if (this.modalVisibility) {
        return 'modal is-block'
      } else {
        return 'modal'
      }
    },
  },
  methods: {
    closeModal(): void {
      this.modalVisibility = false
    },
  },
}
</script>
