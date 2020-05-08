<template>
  <div>
    <advanced-search v-on:searchPosts='setQuery'></advanced-search>
    <posts v-bind:keywordOr='this.keywordOr'></posts>
  </div>
</template>

<script lang='ts'>
import Posts from '../components/posts.vue'
import AdvancedSearch from '../components/advancedSearch.vue'

export default {
  data() {
    return {
      keywordOr: '',
    }
  },
  components: { Posts, AdvancedSearch },
  methods: {
    setQuery(query) {
      this.keywordOr = query.keywordOr
    },
  },
}
</script>

