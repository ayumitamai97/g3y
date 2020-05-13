<template>
  <div :class='modalVisibilityClass'>
    <div class='modal-background' @click='closeModal'></div>
    <div class='modal-card mt-20'>
      <div class='modal-card-head'>
        <h1 class='modal-card-title is-2'>Advanced Search</h1>
        <button class='delete' @click='closeModal'></button>
      </div>

      <div class='modal-card-body'>
        <h4 class="field is-size-5">Search by content</h4>
        <div class="field">
          <input type='text' v-model='query.qContentOr' class='input' placeholder='OR search'>
        </div>
        <div class="field">
          <input type='text' v-model='query.qContentAnd' class='input' placeholder='AND search'>
        </div>
        <hr>

        <h4 class="field is-size-5">Search by user</h4>
        <div class='field'>
          <input type='text' v-model='query.qUsername' class='input' placeholder='Username'>
        </div>
        <hr>

        <h4 class="field is-size-5">Search by date</h4>
        <datepicker v-model='query.qCreatedAtAfter'
         input-class='input' wrapper-class='field' :typeable=true
         calendar-class='box p-10' format='yyyy/MM/dd'
         placeholder='Posted after (date)'
        ></datepicker>
        <datepicker v-model='query.qCreatedAtBefore'
         input-class='input' wrapper-class='field' :typeable=true
         calendar-class='box p-10' format='yyyy/MM/dd'
         placeholder='Posted before (date)'
        ></datepicker>
      </div>

      <div class='modal-card-foot'>
        <button class='button' @click='search'>Search</button>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
import Datepicker from 'vuejs-datepicker'

export default {
  components: { Datepicker },
  data(): Object {
    return {
      query: {
        qContentOr: '',
        qContentAnd: '',
        qUsername: '',
        qCreatedAtAfter: '',
        qCreatedAtBefore: '',
      },
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
      this.$router.push({
        path: 'explore',
        query: { qKeyword: this.query.qKeyword, queryField: 'posts' },
      })
    },
  },
}
</script>
