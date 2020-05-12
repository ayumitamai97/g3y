<template>
  <div class='container'>
    <!-- TODO: error, warning 共通化 -->
    <posts v-if='isExactSearch' v-bind:query='query'></posts>
    <fuzzy-posts v-if='isFuzzySearch' v-bind:query='query'></fuzzy-posts>
  </div>
</template>

<script lang='ts'>
import Posts from './posts.vue'
import FuzzyPosts from './fuzzyPosts.vue'

export default {
  components: { Posts, FuzzyPosts },
  data(): Object {
    return {
      page: 0,
      showMoreEnabled: true,
      errors: [],
      warnings: [],
    }
  },
  props: {
    query: {
      type: Object,
      default: (): Object => ({
        qContentOr: '',
        qContentAnd: '',
        qUsername: '',
        qKeyword: '',
        qCreatedAtAfter: '',
        qCreatedAtBefore: '',
      }),
    },
    queryField: {
      type: String,
      default: 'posts',
    },
  },
  computed: {
    isFuzzySearch(): Boolean {
      return this.queryField === 'fuzzyPosts'
    },
    isExactSearch(): Boolean {
      return this.queryField === 'posts'
    },
  },
}
</script>
