<template>
  <div class='columns'>
    <section class='section column is-3 is-offset-1'>
      <div>
        <h1 class='title is-1 mb-20'>
          <router-link to='/'>
            gummy
          </router-link>
        </h1>
      </div>
      <div>
        <div v-if='!isAuthenticated()'>
          <router-link
            to='/login'
            class='has-text-grey-dark'
          >
            Login
          </router-link>
          <span> | </span>
          <router-link
            to='/signup'
            class='has-text-grey-dark'
          >
            Signup
          </router-link>
        </div>
        <div v-if='isAuthenticated()'>
          <p class='mb-20'>
            Logged in as {{ userName }}
          </p>
          <div class='menu'>
            <ul class='menu-list'>
              <li>
                <router-link
                  :to='"/"'
                  exact
                >
                  Home
                </router-link>
              </li>
              <li>
                <router-link :to='"/explore"'>
                  Explore
                </router-link>
              </li>
              <li>
                <router-link :to='"/relationship"'>
                  Relationship
                </router-link>
              </li>
              <li>
                <a
                  class='has-text-grey-light'
                  @click='logout'
                >Logout</a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
    <section class='section column is-four-fifths is-6'>
      <router-view />
    </section>
  </div>
</template>

<script lang='ts'>
import authUtil from '../src/authUtil.ts'

export default {
  name: 'App',
  computed: {
    userName(): String {
      return this.$store.state.userName
    },
  },
  created(): void {
    this.isAuthenticated = authUtil.isAuthenticated
  },
  methods: {
    logout(): void {
      localStorage.removeItem('access')
      localStorage.removeItem('accessExpiresAt')
      localStorage.removeItem('vuex')
      this.$router.push('/login')
    },
  },
}
</script>
