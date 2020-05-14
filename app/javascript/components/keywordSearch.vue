<template>
  <div class='field level-right is-grouped h-3rem'>
    <div class='control has-icons-right is-expanded'>
      <input
        v-model='query.qKeyword'
        class='input is-rounded'
        placeholder='Username or post content'
        @keydown.enter='search'
      >
      <span class='icon is-small is-right'>
        <font-awesome-icon :icon='["fas", "search"]' />
      </span>
    </div>

    <span
      v-if='showAdvancedButton'
      class='icon is-large'
    >
      <router-link
        class='level-right has-text-grey-light'
        :to='{ path: "explore", query: { advancedSearch: true } }'
      >
        <font-awesome-icon
          :icon='["fas", "ellipsis-h"]'
          class='fa-lg has-text-grey-lighter'
        />
      </router-link>
    </span>
  </div>
</template>

<script lang='ts'>
import { library } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faEllipsisH } from '@fortawesome/free-solid-svg-icons'


library.add(faSearch, faEllipsisH)

const jpKeyCode: number = 13

export default {
  props: {
    showAdvancedButton: {
      type: Boolean,
      default: true,
    },
  },
  data(): Object {
    return {
      query: { qKeyword: '' },
    }
  },
  methods: {
    search(event): void {
      if (event.keyCode !== jpKeyCode || this.query.qKeyword === '') return

      this.$emit('search', {
        qKeyword: this.query.qKeyword,
        queryField: 'fuzzyPosts',
      })
    },
  },
}
</script>
