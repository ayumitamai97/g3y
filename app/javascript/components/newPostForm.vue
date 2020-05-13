<template>
  <div class='container mb-20'>
    <div class='field'>
      <div class='control'>
        <textarea placeholder="What's new?" v-model='post.content'
         class='textarea new-post-form__textarea'
         rows='1' @input='expandTextarea'
        ></textarea>
      </div>
    </div>
    <div class='field level-right'>
      <div class='control'>
        <button
         class='button is-primary is-rounded has-text-weight-bold' @click='createPost'>
          Submit
        </button>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

export default {
  data(): Object {
    return {
      post: { content: '' },
    }
  },
  methods: {
    expandTextarea(event): void {
      const { target } = event
      target.style.height = target.scrollHeight
    },
    async createPost(): Promise<void> {
      await this.$apollo.mutate({
        mutation: gql`mutation createPost ($content: String!) {
          createPost(input: { content: $content }) {
            post {
              content
            }
            errors
          }
        }`,
        variables: {
          content: this.post.content,
        },
      })
      this.$store.commit('postsUpdated', Date.now())
      this.post.content = ''
    },
  },
}
</script>
