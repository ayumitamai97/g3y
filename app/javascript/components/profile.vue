<template>
  <div class='container'>
    <h2 class='title is-size-2 has-text-grey-dark'>
      Your Profile
    </h2>
    <div>
      <input type='file' @input='upload'>
    </div>
  </div>
</template>

<script lang='ts'>
export default {
  data(): object {
    return {
    }
  },
  methods: {
    upload(event): void {
      console.log(event.target.value)
    },
  },
}
</script>

