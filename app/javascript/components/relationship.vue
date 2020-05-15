<template>
  <div>
    <div class='columns'>
      <div class='column is-6'>
        <h1 class='title is-size-2 has-text-grey-dark'>
          Your Relationship
        </h1>
      </div>
      <div class='column is-6'>
        <!-- TODO: search form -->
      </div>
    </div>
    <div class='tabs is-centered is-large is-fullwidth'>
      <ul>
        <li
          :class='{ "is-active has-text-weight-bold": activeTab == "following" }'
          @click='setActiveTab("following")'
        >
          <a>Following</a>
        </li>
        <li
          :class='{ "is-active has-text-weight-bold": activeTab == "followers" }'
          @click='setActiveTab("followers")'
        >
          <a>Followers</a>
        </li>
      </ul>
    </div>
    <following v-show='activeTab == "following"' />
    <div v-show='activeTab == "followers"'>
      Not yet implemented...
    </div>
  </div>
</template>

<script lang='ts'>
import Following from './following.vue'

export default {
  components: { Following },
  data(): Object {
    return {
      activeTab: 'following',
      // TODO: initialize props `query` in order to pass to following.vue
    }
  },
  computed: {
  },
  methods: {
    setActiveTab(name): void {
      this.activeTab = name
    },
  },
}
</script>
