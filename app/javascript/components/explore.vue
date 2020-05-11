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
    <posts v-bind:query='this.query'></posts>
  </div>
</template>

<script lang='ts'>
import { library } from '@fortawesome/fontawesome-svg-core'
import { faSearch } from '@fortawesome/free-solid-svg-icons'
import Posts from './posts.vue'
import AdvancedSearch from './advancedSearch.vue'

library.add(faSearch)

export default {
  data() {
    return {
      query: { qContentOr: '', qContentAnd: '', qUsername: '' },
    }
  },
  components: { Posts, AdvancedSearch },
  methods: {
    setQuery(query): void {
      this.query = query
    },
  },
}
</script>
