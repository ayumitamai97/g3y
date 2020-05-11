<template>
  <div :class='modalVisibilityClass'>
    <div class='modal-background'></div>
    <div class='modal-card mt-20'>
      <div class='modal-card-head'>
        <h1 class='modal-card-title is-2'>Advanced Search</h1>
        <button class='delete' @click='closeModal'></button>
      </div>
      <div class='modal-card-body'>
        <input type='text' v-model='query.qContentOr' class='input' placeholder='OR search'>
      </div>
      <div class='modal-card-body'>
        <input type='text' v-model='query.qContentAnd' class='input' placeholder='AND search'>
      </div>
      <div class='modal-card-body'>
        <input type='text' v-model='query.qUsername' class='input' placeholder='username'>
      </div>
      <div class='modal-card-foot'>
        <button class='button' @click='search'>Search</button>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
export default {
  data() {
    return {
      query: { qContentOr: '', qContentAnd: '', qUsername: '' },
    }
  },
  computed: {
    modalVisibilityClass(): String {
      return this.modalVisibility ? 'modal is-block' : 'modal'
    },
    modalVisibility(): Boolean {
      return this.$route.query.advancedSearch
    },
  },
  methods: {
    search(): void {
      this.closeModal()
      this.$emit('searchPosts', this.query)
    },
    closeModal(): void {
      this.$router.push('explore')
    },
  },
}
</script>
