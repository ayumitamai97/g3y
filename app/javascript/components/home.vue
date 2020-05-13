<template>
  <div class='container'>
    <div class='columns'>
      <div class='column is-6'>
        <h2 class='title is-size-2 has-text-grey-dark'>Home Timeline</h2>
      </div>
      <div class='column is-6'>
        <keyword-search @search='keywordSearch' :showAdvancedButton=false></keyword-search>
      </div>
    </div>
    <new-post-form></new-post-form>
    <div>
      <timeline></timeline>
    </div>
  </div>
</template>

<script lang='ts'>
import Timeline from './timeline.vue'
import KeywordSearch from './keywordSearch.vue'
import NewPostForm from './newPostForm.vue'
import authUtil from '../src/authUtil.ts'

export default {
  components: { Timeline, KeywordSearch, NewPostForm },
  data(): Object {
    return {
      query: { qKeyword: '' },
    }
  },
  created(): void {
    if (!authUtil.isAuthenticated()) {
      this.$router.push('/login')
    }
  },
  methods: {
    keywordSearch(query): void {
      this.$router.push({
        path: 'explore',
        query: { qKeyword: query.qKeyword, queryField: query.queryField },
      })
    },
  },
}
</script>
