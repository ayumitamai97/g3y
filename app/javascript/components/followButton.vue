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
      default: null,
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
    },
  },
}
</script>
