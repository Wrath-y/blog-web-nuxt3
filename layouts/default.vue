<template>
    <div>
        <Navigator />
        <slot />
    </div>
</template>

<script>
export default {
    head: {
        script: [
            // { src: 'https://live2d-wrath.oss-cn-shanghai.aliyuncs.com/jquery.min.js' },
            // { src: 'https://live2d-wrath.oss-cn-shanghai.aliyuncs.com/autoload.js' }
        ],
        link: [
            // { rel: 'stylesheet', href: 'https://live2d-wrath.oss-cn-shanghai.aliyuncs.com/font-awesome.min.css' }
        ]
    },
    data() {
        return {};
    },
    computed: {},
    watch: {},
    methods: {},
    mounted() {
    },
    beforeDestroy() {
    },
};
</script>

<style>
body {
    font-family: 'Source Sans Pro', sans-serif;
    color: #404040;
    font-size: 15px;
    line-height: 1.5;
    margin: 0;
    cursor: url(https://gilgamesh-10047150.cos.ap-shanghai.myqcloud.com/normal.cur), auto;
    text-shadow: 0 0 1px rgba(0, 0, 0, .1);
}

body .el-message {
    margin-top: 50px;
}

p {
    margin-bottom: 1.5em;
    cursor: url(https://gilgamesh-10047150.cos.ap-shanghai.myqcloud.com/texto.cur), auto;
}

a {
    color: #504e4e;
    text-decoration: none;
    transition: color .2s ease-out, border .2s ease-out, opacity .2s ease-out;
}

a:hover {
    color: #e67474;
    text-decoration: none;
    cursor: url(https://gilgamesh-10047150.cos.ap-shanghai.myqcloud.com/ayuda.cur), auto;
}
</style>
