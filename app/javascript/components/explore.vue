<template>
  <div>
    <div class='columns'>
      <div class='column is-4'>
        <h1 class='title is-size-2 has-text-grey-dark'>
          Explore
        </h1>
      </div>
      <div class='column is-8'>
        <keyword-search
          :key='kwSearchComponentKey'
          @search='setQuery'
        />
      </div>
    </div>
    <advanced-search
      :key='advSearchComponentKey'
      @searchPosts='setQuery'
    />
    <timeline
      :query='query'
      :query-field='query.queryField'
    />
  </div>
</template>

<script lang='ts'>
import Timeline from './timeline.vue'
import KeywordSearch from './keywordSearch.vue'
import AdvancedSearch from './advancedSearch.vue'

export default {
  components: { Timeline, KeywordSearch, AdvancedSearch },
  data(): Object {
    return {
      query: {},
      // ref. force re-render https://github.com/vuejs/Discussion/issues/356#issuecomment-336060875
      kwSearchComponentKey: 0,
      advSearchComponentKey: 0,
    }
  },
  beforeRouteEnter(route, redirect, next): void {
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
    setQuery(query): void {
      this.query = query
      if (query.qKeyword) {
        this.advSearchComponentKey += 1
      } else {
        this.kwSearchComponentKey += 1
      }
    },
  },
}
</script>
