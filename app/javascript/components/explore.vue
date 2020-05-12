<template>
  <div>
    <div class='columns'>
      <div class='column is-4'>
        <h1 class='title is-size-2'>Explore</h1>
      </div>
      <div class='column is-8'>
        <keyword-search @search='keywordSearch'></keyword-search>
      </div>
    </div>
    <advanced-search v-on:searchPosts='setQuery'></advanced-search>
    <timeline v-bind:query='this.query' v-bind:queryField='this.query.queryField'></timeline>
  </div>
</template>

<script lang='ts'>
import Timeline from './timeline.vue'
import KeywordSearch from './keywordSearch.vue'
import AdvancedSearch from './advancedSearch.vue'

export default {
  data(): Object {
    return {
      query: {},
    }
  },
  components: { Timeline, KeywordSearch, AdvancedSearch },
  beforeRouteEnter(route, redirect, next) {
    next((vm: any) => {
      vm.setQuery(route.query)
      if (route.query.queryField) {
        vm.$router.replace({ query: {} })
      }
    })
  },
  beforeUpdate(): void {
    if (this.$route.query.queryField) {
      this.$router.replace({ query: {} })
    }
  },
  methods: {
    keywordSearch(query): void {
      this.setQuery(query)
    },
    setQuery(query): void {
      this.query = query
    },
  },
}
</script>
