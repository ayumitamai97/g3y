<template>
  <div>
    <button
      class='button is-rounded'
      :class='followButtonClassName'
      @click='requestFollowStatusChange'
      @mouseover='toggleClassName("hover"); toggleFollowStatusText("hover")'
      @mouseleave='toggleClassName("blur"); toggleFollowStatusText("blur")'
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
    },
  },
  data() {
    return {
      followStatus: 'following',
      followStatusText: 'Following',
      followButtonClassName: 'is-outlined is-primary',
    }
  },
  methods: {
    // TODO: refactor!!!
    async requestFollowStatusChange(): Promise<void> {
      if (this.followStatus == 'unfollowed') {
        await this.follow()
        this.followStatus = 'following'
        this.followStatusText = 'Following'
      } else if (this.followStatus == 'following') {
        await this.unfollow()
        this.followStatus = 'unfollowed'
        this.followStatusText = 'Follow'
      }
    },
    toggleClassName(status): void {
      if (status === 'hover') {
        if (this.followStatus === 'unfollowed') {
          this.followButtonClassName = 'is-primary'
        } else if (this.followStatus === 'following') {
          this.followButtonClassName = 'is-danger'
        }
      } else if (status==='blur') {
        this.followButtonClassName = 'is-outlined is-primary'
      }
    },
    toggleFollowStatusText(status): void {
      if (status === 'hover' && this.followStatus === 'following') {
        this.followStatusText = 'Unfollow'
      } else if (status==='hover' && this.followStatus === 'unfollowed') {
        this.followStatusText = 'Follow'
      } else if (status==='blur' && this.followStatus === 'following') {
        this.followStatusText = 'Following'
      } else if (status==='blur' && this.followStatus === 'unfollowed') {
        this.followStatusText = 'Follow'
      }
    },
    async follow(): Promise<Object> {
      return this.$apollo.mutate({
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
    },
    async unfollow(): Promise<Object> {
      return this.$apollo.mutate({
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
    },
  },
}
</script>
