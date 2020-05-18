<template>
  <div>
    <div class='columns'>
      <div class='column is-12'>
        <h1 class='title is-size-2 has-text-grey-dark'>
          Relationship
        </h1>
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
    <following
      v-if='activeTab == "following"'
      :query='query'
    />
    <div v-if='activeTab == "followers"'>
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
      query: {},
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
