<template>
  <div>
    <button
      class='button is-rounded'
      :class='followButtonClassName'
      @click='requestFollowStatusChange'
      @mouseover='formatFollowStatusText("hover")'
      @mouseleave='formatFollowStatusText("blur")'
    >
      {{ followStatusText }}
    </button>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

export default {
  props: {
    followingId: {
      type: String,
      default: () => {},
    },
  },
  data() {
    return {
      followStatus: 'following',
      followStatusText: 'Following',
    }
  },
  computed: {
    followButtonClassName(): String {
      const classNameMapper: Object = {
        Follow: 'is-primary is-outlined',
        Following: 'is-primary is-outlined',
        Unfollow: 'is-danger',
      }

      return classNameMapper[this.followStatusText]
    },
  },
  created() {
    this.$apollo.queries.relationship.refetch()
  },
  apollo: {
    relationship: {
      query: gql`query relationship ($followingId: ID!) {
        relationship (followingId: $followingId) {
          id
        }
      }`,
      variables(): Object {
        return {
          followingId: this.followingId,
        }
      },
      result({ data }): void {
        if (!data) return

        if (data.relationship) {
          this.followStatus = 'following'
          this.followStatusText = 'Following'
        } else {
          this.followStatus = 'unfollowed'
          this.followStatusText = 'Follow'
        }
      },
    },
  },
  methods: {
    formatFollowStatusText(eventName): void {
      const textMappter: Object = {
        unfollowed: () => 'Follow',
        following: (e) => (e === 'hover' ? 'Unfollow' : 'Following'),
      }
      this.followStatusText = textMappter[this.followStatus](eventName)
    },
    async requestFollowStatusChange(): Promise<void> {
      if (this.followStatus === 'unfollowed') {
        await this.follow()
      } else if (this.followStatus === 'following') {
        await this.unfollow()
      }
    },
    async follow(): Promise<void> {
      this.$apollo.mutate({
        mutation: gql`mutation followUser ($followingId: ID!) {
          followUser(input: { followingId: $followingId }) {
            following {
              id
              name
            }
            errors
          }
        }`,
        variables: {
          followingId: this.followingId,
        },
      })
      this.followStatus = 'following'
      this.followStatusText = 'Following'
      this.$store.commit('relationshipUpdated', Date.now())
    },
    async unfollow(): Promise<void> {
      this.$apollo.mutate({
        mutation: gql`mutation unfollowUser ($followingId: ID!) {
          unfollowUser(input: { followingId: $followingId }) {
            following {
              id
              name
            }
            errors
          }
        }`,
        variables: {
          followingId: this.followingId,
        },
      })
      this.followStatus = 'unfollowed'
      this.followStatusText = 'Follow'
      this.$store.commit('relationshipUpdated', Date.now())
    },
  },
}
</script>
