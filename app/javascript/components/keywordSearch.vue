<template>
  <div class='field level-right is-grouped h-3rem'>
    <div class='control has-icons-right is-expanded'>
      <input
       class='input is-rounded' @keydown.enter='search' v-model='query.qKeyword'
       placeholder='Username or post content'
      >
      <span class='icon is-small is-right'>
        <font-awesome-icon :icon="['fas', 'search']" />
      </span>
    </div>

    <span class='icon is-large' v-if='showAdvancedButton'>
      <router-link class='level-right has-text-grey-light'
       :to='{ path: "explore", query: { advancedSearch: true } }'>
        <font-awesome-icon :icon="['fas', 'ellipsis-h']"
         class='fa-lg has-text-grey-lighter' />
      </router-link>
    </span>
  </div>
</template>

<script lang='ts'>
import { library } from '@fortawesome/fontawesome-svg-core'
import { faSearch } from '@fortawesome/free-solid-svg-icons'
import { faEllipsisH } from '@fortawesome/free-solid-svg-icons'

library.add(faSearch, faEllipsisH)

const jpKeyCode: number = 13

export default {
  data(): Object {
    return {
      query: { qKeyword: '' },
    }
  },
  props: {
    showAdvancedButton: {
      type: Boolean,
      default: true,
    }
  },
  methods: {
    search(event): void {
      if (event.keyCode !== jpKeyCode) return

      this.$emit('search', {
        qKeyword: this.query.qKeyword,
        queryField: 'fuzzyPosts'
      })
    },
  },
}
</script>

