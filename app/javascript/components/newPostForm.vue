<template>
  <div class='container mb-20'>
    <errors :errors='errors' />
    <div class='field'>
      <div class='control'>
        <textarea
          v-model='post.content'
          placeholder="What's new?"
          class='textarea new-post-form__textarea'
          rows='1'
          @input='expandTextarea'
        />
      </div>
    </div>
    <div class='field level-right'>
      <div class='control'>
        <button
          class='button is-primary is-rounded has-text-weight-bold'
          @click='createPost'
        >
          Submit
        </button>
      </div>
    </div>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'
import Errors from './errors.vue'

export default {
  components: { Errors },
  data(): Object {
    return {
      post: { content: '' },
      errors: [],
      textarea: '',
    }
  },
  methods: {
    expandTextarea(event): void {
      const { target } = event
      target.style.height = 'initial'
      target.style.height = target.scrollHeight + 1 // 微調整
      this.textarea = target
    },
    async createPost(): Promise<void> {
      const request = this.$apollo.mutate({
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
      const { data } = await request
      if (data.createPost.post) {
        this.$store.commit('postsUpdated', Date.now())
        this.post.content = ''
        this.textarea.style.height = 'auto'
      } else if (data.createPost.errors.length > 0) {
        this.errors = data.createPost.errors
      }
    },
  },
}
</script>
