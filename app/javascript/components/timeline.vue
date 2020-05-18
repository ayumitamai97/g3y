<template>
  <div class='container'>
    <posts
      v-if='isExactSearch'
      :query='query'
    />
    <fuzzy-posts
      v-if='isFuzzySearch'
      :query='query'
    />
  </div>
</template>

<script lang='ts'>
import Posts from './posts.vue'
import FuzzyPosts from './fuzzyPosts.vue'

export default {
  components: { Posts, FuzzyPosts },
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
        qOnlyFollowings: false,
      }),
    },
    queryField: {
      type: String,
      default: 'posts',
    },
  },
  data(): Object {
    return {
      page: 0,
      showMoreEnabled: true,
      errors: [],
      warnings: [],
    }
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
