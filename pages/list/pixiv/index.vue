<template>
    <ClientOnly>
        <div style="height: 100px"></div>
        <Waterfall :list="list" :breakpoints="{
            3000: { rowPerView: 5 },
            1200: { rowPerView: 4, }
            , 800: { rowPerView: 3, }, 500: { rowPerView: 2, }
        }" :loadProps="loadProps">
            <template #item="{ item, url, index }">
                <div class="card">
                    <LazyImg :url="url" />
                </div>
            </template>
        </Waterfall>
    </ClientOnly>
</template>

<script setup>
import { LazyImg, Waterfall } from 'vue-waterfall-plugin-next'
import 'vue-waterfall-plugin-next/dist/style.css'
import loading from 'assets/loading.gif'

const loadProps = ref({
    loading
})
const list = ref([])
const form = ref({
    page_size: 15,
    next_marker: "",
})
const page = ref(1)

let hasFetchedData = false
let hasFetchPages = []

const fetchData = async () => {
    const {
        data
    } = await useHttpGet("/api/pixivs", `/api/pixivs?${toQuery(form.value)}`, {});
    if (data.value) {
        list.value = list.value.concat(data.value.Objects.map((i) => {
            i.src = 'https://wrath-pixiv.oss-cn-shanghai.aliyuncs.com/' + encodeUrl(i.Key) + '?x-oss-process=image/resize,l_300';
            return i;
        }));
        form.value.next_marker = data.value.NextMarker
    }
    hasFetchedData = false
}

const toQuery = (ob) => {
    return Object.keys(ob).map(function (key) {
        return encodeURIComponent(key) + "=" + encodeURIComponent(ob[key]);
    }).join("&");
}

const encodeUrl = (str) => {
    str = encodeURIComponent(str);
    str = str.replace(/\+/g, '%2B');
    return str;
}

const scrolls = async () => {
    if (hasFetchPages.includes(page.value)) {
        return
    }
    const viewportHeight = window.innerHeight || document.documentElement.clientHeight;
    const threshold = viewportHeight * 0.8;

    if (!hasFetchedData && document.documentElement.scrollTop > threshold * (page.value)) {
        hasFetchedData = true
        hasFetchPages.push(page.value)
        page.value = page.value + 1;
        await fetchData();
    }
}

onMounted(() => {
    window.addEventListener('scroll', scrolls, true);
})

fetchData()

</script>

<style scope lang="scss">
#gallery {
    text-align: center;
}
</style>
