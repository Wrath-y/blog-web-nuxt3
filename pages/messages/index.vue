<template>
    <div class="wrap">
        <div class="top"></div>
        <el-card v-loading="loading">
            <div v-html="form.html"></div>
        </el-card>
        <ArticleComment :id=1 />
    </div>
</template>

<script setup>

const loading = ref(false)
const form = ref({})

const fetchData = async () => {
    loading.value = true

    const {
        data
    } = await useHttpGet("/api/article/1", `/api/article/1`, {});
    if (data.value) {
        form.value = data.value
    }
    loading.value = false
}

useAsyncData(fetchData)

useHead({
    script: [{ src: '//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/highlight.min.js' }],
    link: [{ rel: "stylesheet", href: "https://cdn.bootcss.com/github-markdown-css/2.10.0/github-markdown.min.css" }],
})

</script>

<style scoped lang="scss">
.wrap {
    width: 50%;
    margin: auto;

    .top {
        padding-top: 81px;
    }
}
</style>

