<template>
  <div>
    <h2 class='title is-size-2 has-text-grey-dark'>
      Relationship
    </h2>
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
  data(): object {
    return {
      activeTab: 'following',
      query: {},
    }
  },
  methods: {
    setActiveTab(name): void {
      this.activeTab = name
    },
  },
}
</script>
