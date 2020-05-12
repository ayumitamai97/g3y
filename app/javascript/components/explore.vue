<template>
  <div>
    <div class='columns'>
      <div class='column is-6'>
        <h1 class='title is-size-2'>Explore</h1>
      </div>
      <div class='column is-6'>
        <router-link class='level-right is-size-2 has-text-grey-light'
         :to='{ path: "explore", query: { advancedSearch: true } }'
        >
          <font-awesome-icon :icon="['fas', 'search']" />
        </router-link>
      </div>
    </div>
    <advanced-search v-on:searchPosts='setQuery'></advanced-search>
    <posts v-bind:query='this.query' v-bind:queryField='this.query.queryField'></posts>
  </div>
</template>

<script lang='ts'>
import { library } from '@fortawesome/fontawesome-svg-core'
import { faSearch } from '@fortawesome/free-solid-svg-icons'
import Posts from './posts.vue'
import AdvancedSearch from './advancedSearch.vue'

library.add(faSearch)

export default {
  data(): Object {
    return {
      query: {},
    }
  },
  components: { Posts, AdvancedSearch },
  beforeRouteEnter(route, redirect, next) {
    next((vm: any) => {
      vm.setQuery(route.query)
      if (route.fullPath !== route.path) {
        vm.$router.replace({ query: {} })
      }
    })
  },
  methods: {
    setQuery(query): void {
      this.query = query
    },
  },
}
</script>
