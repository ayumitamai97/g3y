<template>
  <div :class='modalVisibilityClass'>
    <div
      class='modal-background'
      @click='closeModal'
    />
    <div class='modal-card mt-20'>
      <div class='modal-card-head'>
        <h1 class='modal-card-title is-2 has-text-weight-bold'>
          Advanced Search
        </h1>
        <button
          class='delete'
          @click='closeModal'
        />
      </div>

      <div class='modal-card-body'>
        <h4 class='field is-size-5'>
          Search by content
        </h4>
        <div class='field'>
          <input
            v-model='query.qContentOr'
            type='text'
            class='input advanced-search-form__input'
            placeholder='OR search'
          >
        </div>
        <div class='field'>
          <input
            v-model='query.qContentAnd'
            type='text'
            class='input advanced-search-form__input'
            placeholder='AND search'
          >
        </div>
        <hr>

        <h4 class='field is-size-5'>
          Search by user
        </h4>
        <div class='field'>
          <input
            v-model='query.qUsername'
            type='text'
            class='input advanced-search-form__input'
            placeholder='Username'
          >
        </div>
        <hr>

        <h4 class='field is-size-5'>
          Search by date
        </h4>
        <datepicker
          v-model='query.qCreatedAtAfter'
          input-class='input advanced-search-form__input'
          wrapper-class='field'
          :typeable='true'
          calendar-class='box p-10'
          format='yyyy/MM/dd'
          placeholder='Posted after (date)'
        />
        <datepicker
          v-model='query.qCreatedAtBefore'
          input-class='input advanced-search-form__input'
          wrapper-class='field'
          :typeable='true'
          calendar-class='box p-10'
          format='yyyy/MM/dd'
          placeholder='Posted before (date)'
        />
      </div>

      <div class='modal-card-foot'>
        <button
          class='button is-rounded is-primary'
          @click='search'
        >
          Search
        </button>
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
